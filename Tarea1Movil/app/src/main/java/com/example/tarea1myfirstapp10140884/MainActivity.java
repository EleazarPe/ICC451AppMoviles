package com.example.tarea1myfirstapp10140884;

import static android.provider.AlarmClock.EXTRA_MESSAGE;

import androidx.appcompat.app.AppCompatActivity;

import android.app.DatePickerDialog;
import android.content.Intent;
import android.icu.util.Calendar;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.CheckBox;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.Spinner;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {
    public static final String EXTRA_MESSAGE = "com.example.MyFirstApp10140884.MESSAGE";

    private Spinner spinner1;
    private EditText editTextDate;
    //private   RadioGroup radioGroup = findViewById(R.id.radiogr);;
    private RadioButton r1, r2;

    private CheckBox  c1,c2, c3, c4, c5, c6;
    private EditText txt1,txt2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        txt1 = (EditText) findViewById(R.id.txtname);
        txt2 = (EditText) findViewById(R.id.txtapellido);
        r1 = findViewById(R.id.radioButton1);
        r1.setChecked(true);
        r2 = findViewById(R.id.radioButton2);
        editTextDate = findViewById(R.id.editTextDate);
        spinner1 = (Spinner) findViewById(R.id.spinner);
        String[] opciones = {"Seleccionar","Masculino", "Femenino"};
        ArrayAdapter <String> spineradaptador = new ArrayAdapter<>(this, android.R.layout.simple_list_item_1, opciones);
        spinner1.setAdapter(spineradaptador);

        c1 = (CheckBox) findViewById(R.id.checkBox1);
        c2 = (CheckBox) findViewById(R.id.checkBox2);
        c3 = (CheckBox) findViewById(R.id.checkBox3);
        c4 = (CheckBox) findViewById(R.id.checkBox4);
        c5 = (CheckBox) findViewById(R.id.checkBox5);
        c6 = (CheckBox) findViewById(R.id.checkBox6);


        RadioGroup radioGroup = findViewById(R.id.radiogr);

        radioGroup.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup group, int checkedId) {
                if(r1.isChecked()){
                    c1.setEnabled(true);
                    c2.setEnabled(true);
                    c3.setEnabled(true);
                    c4.setEnabled(true);
                    c5.setEnabled(true);
                    c6.setEnabled(true);
                    //Toast.makeText(MainActivity.this, "Ninguna opción seleccionada", Toast.LENGTH_SHORT).show();
                }
                if(r2.isChecked()){
                    c1.setChecked(false);
                    c2.setChecked(false);
                    c3.setChecked(false);
                    c4.setChecked(false);
                    c5.setChecked(false);
                    c6.setChecked(false);

                    c1.setEnabled(false);
                    c2.setEnabled(false);
                    c3.setEnabled(false);
                    c4.setEnabled(false);
                    c5.setEnabled(false);
                    c6.setEnabled(false);
                }
            }
        });

    }
    public void showDatePickerDialog(View view) {
        Calendar calendar = Calendar.getInstance();
        int year = calendar.get(Calendar.YEAR);
        int month = calendar.get(Calendar.MONTH);
        int day = calendar.get(Calendar.DAY_OF_MONTH);
        DatePickerDialog datePickerDialog = new DatePickerDialog(this, new DatePickerDialog.OnDateSetListener() {
            @Override
            public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                editTextDate.setText(dayOfMonth + "/" + (month + 1) + "/" + year);
            }
        }, year, month, day);

        datePickerDialog.show();
    }

    public void borrarData(View view){
        spinner1.setSelection(0);
        editTextDate.setText("");
        txt1.setText("");
        txt2.setText("");
        c1.setChecked(false);
        c2.setChecked(false);
        c3.setChecked(false);
        c4.setChecked(false);
        c5.setChecked(false);
        c6.setChecked(false);
        r1.setChecked(true);


    }

    public void sendMessage(View view){

        Intent intent = new Intent(this, MessageActivity.class);
        EditText editText = (EditText) findViewById(R.id.txtname);
        EditText editText2 = (EditText) findViewById(R.id.txtapellido);
        Spinner sp = findViewById(R.id.spinner);
        if( editText.getText().toString().isEmpty() || editText2.getText().toString().isEmpty() || sp.getSelectedItemPosition() == 0 ) {
            Toast.makeText(MainActivity.this, "No se puede enviar el formulario. Olvidaste campos obligatorios", Toast.LENGTH_SHORT).show();
        }else{
            EditText editText3 = (EditText) findViewById(R.id.editTextDate);

            String message = "";
            message += "Hola, mi nombre es: ";
            message += editText.getText().toString();
            message += " ";
            message += editText2.getText().toString();
            message += "\n";
            message += "Soy ";
            message += String.valueOf(sp.getSelectedItem());
            message += ", y naci en la fecha ";
            message += editText3.getText().toString();
            if (r1.isChecked()) {
                message += "\n";
                message += "Me gusta programar. Mis lenguajes favoritos son: ";
                if (c1.isChecked()) {
                    message += " Java,";
                }
                if (c2.isChecked()) {
                    message += " JS,";
                }
                if (c3.isChecked()) {
                    message += " C/C++,";
                }
                if (c4.isChecked()) {
                    message += " Python,";
                }
                if (c5.isChecked()) {
                    message += " Go lang,";
                }
                if (c6.isChecked()) {
                    message += " C#,";
                }

            } else {
                message += "\n";
                message += "No me gusta programar.";
            }
            intent.putExtra(EXTRA_MESSAGE, message);
            startActivity(intent);

        }
    }




}