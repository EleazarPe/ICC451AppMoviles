package com.example.tarea3viewmodelrom;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.lifecycle.ViewModelProvider;

import com.example.tarea3viewmodelrom.data.TareaViewModel;
import com.example.tarea3viewmodelrom.encapsulaciones.Tarea;

//import com.example.tarea3viewmodelrom.encapsulaciones.Almacen;


public class tempActivity extends AppCompatActivity {
    EditText t1, t2;
    Button bt1;
    Tarea tarea;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_temp);
        Intent intent = getIntent();
         tarea = (Tarea) intent.getSerializableExtra("dato_key");
        //Toast.makeText(this, "Tarea creada!   "+tarea.getTitulo(, Toast.LENGTH_SHORT).show();
        t1 = findViewById(R.id.editTextText3);
        t2 = findViewById(R.id.editTextText2);
        bt1 = findViewById(R.id.button5);

        t1.setText(String.valueOf(tarea.getTitulo()));
        t2.setText(String.valueOf(tarea.getContenido()));

        t1.setTextColor(getResources().getColor(android.R.color.black));
        t2.setTextColor(getResources().getColor(android.R.color.black));

        t1.setBackgroundColor(getResources().getColor(android.R.color.transparent));
        t2.setBackgroundColor(getResources().getColor(android.R.color.transparent));
        setTitle("Tarea: "+tarea.getTitulo());


    }
    public void editarTarea(View view){
       // Toast.makeText(this, bt1.getText(), Toast.LENGTH_SHORT).show();
        if(bt1.getText().equals("Editar")){
            bt1.setBackgroundColor(Color.parseColor("#17E860"));
            bt1.setText("Guardar");
            t1.setEnabled(true);
            t1.setBackgroundResource(R.drawable.edittext_backgroundyellow);
            t2.setEnabled(true);
            t2.setBackgroundResource(R.drawable.edittext_backgroundyellow);
        }else if(bt1.getText().equals("Guardar")){
            bt1.setBackgroundColor(Color.parseColor("#FF9800"));
            t1.setEnabled(false);
            t1.setBackgroundResource(R.drawable.edittext_backgroundwhite);
            t2.setEnabled(false);
            t2.setBackgroundResource(R.drawable.edittext_backgroundwhite);
            bt1.setText("Editar");
            TareaViewModel tmodel = new ViewModelProvider(this).get(TareaViewModel.class);
            tarea.setTitulo(t1.getText().toString());
            tarea.setContenido(t2.getText().toString());
            tmodel.update(tarea);
            Toast.makeText(this, "Tarea Actualizada", Toast.LENGTH_SHORT).show();
           // Almacen.getInstance().editarTareabyId(Integer.parseInt(getIntent().getStringExtra("dato_key")), t1.getText().toString(),t2.getText().toString());
            setTitle("Tarea: "+t1.getText().toString());
        }
    }

    public void borrarTarea(View view){
        AlertDialog.Builder builder = new AlertDialog.Builder(this);
        builder.setTitle("Confirmar eliminación");
        builder.setMessage("¿Estás seguro de que deseas eliminar esta tarea?");

        builder.setPositiveButton("Sí", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                Context context = view.getContext();
              //  Almacen.getInstance().deleteTareaById(Integer.parseInt(getIntent().getStringExtra("dato_key")));
                TareaViewModel tmodel = new ViewModelProvider((AppCompatActivity) context).get(TareaViewModel.class);
                tmodel.delete(tarea);
                finish();
            }
        });

        builder.setNegativeButton("Cancelar", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
            }
        });


        AlertDialog dialog = builder.create();
        dialog.show();
    }


}
