package com.example.tarea3viewmodelrom.ui.dashboard;

import android.content.res.Configuration;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;


import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.LiveData;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProvider;
import androidx.recyclerview.widget.GridLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

//import com.example.tarea3viewmodelrom.adapters.TareaRAdapter;
import com.example.tarea3viewmodelrom.adapters.TareaRAdapter;
import com.example.tarea3viewmodelrom.data.TareaViewModel;
import com.example.tarea3viewmodelrom.databinding.RecycleviewpageBinding;
//import com.example.tarea3viewmodelrom.encapsulaciones.Almacen;
import com.example.tarea3viewmodelrom.encapsulaciones.Tarea;

import java.util.ArrayList;
import java.util.List;

public class DashboardFragment extends Fragment {

    private RecycleviewpageBinding binding;
    private TareaViewModel  tmodel;

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

        tmodel = new ViewModelProvider(this).get(TareaViewModel.class);

        final TareaRAdapter adapter = new TareaRAdapter(new TareaRAdapter.TareadDiff());
        recyclerView.setAdapter(adapter);

        tmodel.getAll().observe(getViewLifecycleOwner(), tareas -> {

                adapter.submitList(tareas);

        });


        return root;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }

//    public void onResume() {
//        super.onResume();
//        // Llama al método de carga de datos cada vez que la actividad se retoma
//        cargarDatosEnListView();
//    }
//    public void cargarDatosEnListView(){
//        RecyclerView recyclerView = binding.recyclemio;
//
//        int spanCount = 1;
//
//        if (this.getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE) {
//            spanCount = 2;
//        }
//
//        recyclerView.setHasFixedSize(true);
//        recyclerView.setLayoutManager(new GridLayoutManager(getContext(), spanCount));
//
//        recyclerView.setAdapter(new TareaRAdapter(Almacen.getInstance().getListaTareas()));
//    }
}