package com.example.myapplication.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.example.myapplication.R;
import com.example.myapplication.encapsulaciones.Tarea;

import java.util.List;

public class TareaAdapter extends ArrayAdapter<Tarea> {
    public TareaAdapter(@NonNull Context context, @NonNull List<Tarea> tareas) {
        super(context, 0, tareas);
    }

    @NonNull
    @Override
    public View getView(int position, @Nullable View convertView, @NonNull ViewGroup parent) {
        if (convertView == null) {
            convertView = LayoutInflater.from(getContext()).inflate(R.layout.itemtarea, parent, false);
        }
            Tarea item = getItem(position);
            TextView idT =   convertView.findViewById(R.id.txtidTarea);
            TextView tituloT = convertView.findViewById(R.id.txtIdTitulo);
            //Toast.makeText(getContext(), "Tu dato aquí"+item.getTitulo(), Toast.LENGTH_SHORT).show();
            idT.setText(String.valueOf(item.getIdTarea()));
            tituloT.setText(String.valueOf(item.getTitulo()));

            return convertView;

    }
}

