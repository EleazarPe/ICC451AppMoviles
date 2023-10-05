package com.example.tarea3viewmodelrom.encapsulaciones;

import androidx.annotation.NonNull;
import androidx.room.Entity;
import androidx.room.PrimaryKey;

import java.io.Serializable;

@Entity(tableName = "tarea_table")
public class Tarea implements Serializable {
    @PrimaryKey(autoGenerate = true)
    private int idTarea;
    @NonNull
    private String titulo;

    private String contenido;
    private boolean estado;


    public Tarea( String titulo, String contenido, boolean estado){
        this. titulo = titulo;
        this.contenido = contenido;
        this.estado = estado;
    }
    public boolean getEstado() {
        return estado;
    }

    public void setEstado(boolean estado) {
        this.estado = estado;
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

    public String getContentText(){
        return (this.titulo+this.contenido+this.estado);
    }


}
