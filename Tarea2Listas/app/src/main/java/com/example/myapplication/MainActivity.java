package com.example.myapplication;

import static java.security.AccessController.getContext;

import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

import com.example.myapplication.encapsulaciones.Almacen;
import com.google.android.material.bottomnavigation.BottomNavigationView;

import androidx.appcompat.app.AppCompatActivity;
import androidx.navigation.NavController;
import androidx.navigation.Navigation;
import androidx.navigation.ui.AppBarConfiguration;
import androidx.navigation.ui.NavigationUI;

import com.example.myapplication.databinding.ActivityMainBinding;

public class MainActivity extends AppCompatActivity {

    private ActivityMainBinding binding;
    private EditText t1,t2;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        binding = ActivityMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        BottomNavigationView navView = findViewById(R.id.nav_view);
        // Passing each menu ID as a set of Ids because each
        // menu should be considered as top level destinations.
        AppBarConfiguration appBarConfiguration = new AppBarConfiguration.Builder(
                R.id.navigation_home, R.id.navigation_dashboard, R.id.navigation_notifications)
                .build();

        NavController navController = Navigation.findNavController(this, R.id.nav_host_fragment_activity_main);
        NavigationUI.setupActionBarWithNavController(this, navController, appBarConfiguration);
        NavigationUI.setupWithNavController(binding.navView, navController);
    }
    public void enviarData(View view){
        t1 = findViewById(R.id.editTextText);
        t2 = findViewById(R.id.editTextText2);
        //Toast.makeText(getActivity(), "No se puede crear con campos vacios", Toast.LENGTH_SHORT).show();
        if( t1.getText().toString().isEmpty()|| t2.getText().toString().isEmpty()){
            Toast.makeText(this, "No se puede crear con campos vacios", Toast.LENGTH_SHORT).show();
        }else{
            Almacen.getInstance().nuevaTarea(t1.getText().toString(),t2.getText().toString());
            Toast.makeText(this, "Tarea creada!", Toast.LENGTH_SHORT).show();
            t1.setText("");
            t2.setText("");
        }
    }


}