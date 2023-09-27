package com.example.myapplication.encapsulaciones;

public class Tarea {
    private int idTarea;

    private String titulo;

    private String contenido;

    public Tarea(int idTarea, String titulo, String contenido){
        this.idTarea = idTarea;
        this. titulo = titulo;
        this.contenido = contenido;
    }

    public int getIdTarea() {
        return idTarea;
    }

    public void setIdTarea(int idTarea) {
        this.idTarea = idTarea;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getContenido() {
        return contenido;
    }

    public void setContenido(String contenido) {
        this.contenido = contenido;
    }


}
