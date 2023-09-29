package com.example.myapplication.ui.recyvleviewFile;

import android.content.res.Configuration;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.example.myapplication.adapters.TareaAdapter;
import com.example.myapplication.adapters.TareaRAdapter;
import com.example.myapplication.databinding.RecycleviewpageBinding;
import com.example.myapplication.encapsulaciones.Almacen;
import com.example.myapplication.encapsulaciones.Tarea;

import java.util.List;

public class NotificationsFragment extends Fragment {

    private RecycleviewpageBinding binding;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {


        binding = RecycleviewpageBinding.inflate(inflater, container, false);

        View root = binding.getRoot();

        RecyclerView recyclerView = binding.recyclemio;

        int spanCount = 1;

        if (this.getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
            spanCount = 2;
        }

        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new GridLayoutManager(getContext(), spanCount));

        recyclerView.setAdapter(new TareaRAdapter(Almacen.getInstance().getListaTareas()));
        return root;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }

    public void onResume() {
        super.onResume();
        // Llama al método de carga de datos cada vez que la actividad se retoma
        cargarDatosEnListView();
    }
    public void cargarDatosEnListView(){
        RecyclerView recyclerView = binding.recyclemio;

        int spanCount = 1;

        if (this.getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
            spanCount = 2;
        }

        recyclerView.setHasFixedSize(true);
        recyclerView.setLayoutManager(new GridLayoutManager(getContext(), spanCount));

        recyclerView.setAdapter(new TareaRAdapter(Almacen.getInstance().getListaTareas()));
    }
}