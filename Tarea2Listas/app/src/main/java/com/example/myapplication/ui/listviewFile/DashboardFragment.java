package com.example.myapplication.ui.listviewFile;



import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;

import com.example.myapplication.R;
import com.example.myapplication.adapters.TareaAdapter;
import com.example.myapplication.databinding.ListviewpageBinding;
import com.example.myapplication.databinding.RecycleviewpageBinding;
import com.example.myapplication.encapsulaciones.Almacen;
import com.example.myapplication.encapsulaciones.Tarea;
import com.example.myapplication.tempActivity;

import java.util.ArrayList;
import java.util.List;

public class DashboardFragment extends Fragment {

    private ListviewpageBinding binding;
    private ListView listView;
    private ArrayAdapter<Tarea> TareaAdapter;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {

        binding = ListviewpageBinding.inflate(inflater, container, false);
        View root = binding.getRoot();
        listView = root.findViewById(R.id.listviewtab);

        List<Tarea> tlist = Almacen.getInstance().getListaTareas();
        TareaAdapter tareaAdapter = new TareaAdapter(getActivity(), tlist);
        listView.setAdapter(tareaAdapter);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                Intent intent = new Intent(getActivity(), tempActivity.class);
                Tarea tarea = tareaAdapter.getItem(position);
                intent.putExtra("dato_key", String.valueOf(tarea.getIdTarea()));
                startActivity(intent);
            }
        });

        return root;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }

    @Override
    public void onResume() {
        super.onResume();
        // Llama al método de carga de datos cada vez que la actividad se retoma
        cargarDatosEnListView();
    }
    public void cargarDatosEnListView(){List<Tarea> tlist = Almacen.getInstance().getListaTareas();

        TareaAdapter tareaAdapter = new TareaAdapter(getActivity(), tlist);
        listView.setAdapter(tareaAdapter);
    }

}