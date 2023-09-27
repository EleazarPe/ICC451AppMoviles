package com.example.myapplication.encapsulaciones;

import android.util.Log;

import java.util.ArrayList;
import java.util.Iterator;

public class Almacen {
    private static Almacen instancia;
    private ArrayList<Tarea> listaTareas;
    public Almacen(){
        this.listaTareas = new ArrayList<>();
        crearTareaPrueba();
    }

    private void crearTareaPrueba() {
        listaTareas.add(new Tarea(1,"Cocinar","cocinar la comida para el dia de manana:\nEs un arroz con pollo a la crema que sera cocinado a maxima temperatura."));
    }

    public static Almacen getInstance(){
        if(instancia==null){
            instancia = new Almacen();
        }
        return instancia;
    }

    public void nuevaTarea(String titutlo, String cuerpo){
        int temp =1;
        if(listaTareas.isEmpty()){
            listaTareas.add(new Tarea(temp,titutlo,cuerpo));
        }else{

            for (Tarea i: listaTareas
                 ) {
                if( i.getIdTarea()> temp){
                    temp = i.getIdTarea();
                }
            }
            temp++;
            listaTareas.add( new Tarea(temp,titutlo,cuerpo));
        }
    }
    public Tarea buscarTareabyId(int id){
        Tarea temp = null;
        for (Tarea i: listaTareas
             ) {
            if(i.getIdTarea() == id){
                temp = i;
            }
        }
        return temp;
    }
    public void editarTareabyId(int id, String titulo, String cuerpo){

        for (Tarea i: listaTareas
        ) {
            if(i.getIdTarea() == id){
                i.setTitulo(titulo);
                i.setContenido(cuerpo);
            }
        }

    }
    public void deleteTareaById(int id){
        Iterator<Tarea> iterator = listaTareas.iterator();
        while (iterator.hasNext()) {
            Tarea ta = iterator.next();
            if (ta.getIdTarea() == id) {
                iterator.remove();
            }
        }
    }
    public ArrayList<Tarea> getListaTareas() {
        return listaTareas;
    }

    public void setListaTareas(ArrayList<Tarea> listaTareas) {
        this.listaTareas = listaTareas;
    }

}
