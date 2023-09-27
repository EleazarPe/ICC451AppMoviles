package com.example.myapplication.ui.home;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.Toast;
import androidx.annotation.NonNull;
import androidx.fragment.app.Fragment;
import com.example.myapplication.R;
import com.example.myapplication.databinding.FragmentHomeBinding;
import com.example.myapplication.encapsulaciones.Almacen;

public class HomeFragment extends Fragment {

    private FragmentHomeBinding binding;
    private EditText t1,t2;
    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        //View view = inflater.inflate(R.layout.fragment_home, container, false);
        //t1 = view.findViewById(R.id.editTextText);
        //t2 = view.findViewById(R.id.editTextText2);
        //t1.setText("Hola mundo");
        binding = FragmentHomeBinding.inflate(inflater, container, false);
        View root = binding.getRoot();
        return root;
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        binding = null;
    }
}