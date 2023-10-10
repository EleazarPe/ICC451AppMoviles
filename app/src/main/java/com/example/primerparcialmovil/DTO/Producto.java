package com.example.primerparcialmovil.DTO;

import com.google.gson.annotations.SerializedName;

import java.util.ArrayList;

public class Producto {
    @SerializedName("id")
    public Integer id;
    @SerializedName("title")
    public String titulo;
    @SerializedName("description")
    public String descripcion;
    @SerializedName("price")
    public long precio;
    @SerializedName("discountPercentage")
    public double descuento;
    @SerializedName("rating")
    public double rating;
    @SerializedName("stock")
    public long stock;
    @SerializedName("brand")
    public String marca;
    @SerializedName("category")
    public String categoria;
    @SerializedName("thumbnail")
    public String logo;
    @SerializedName("images")
    public ArrayList<String> fotos;

    public Producto(Integer id, String titulo, String descripcion, long precio, double descuento, double rating, long stock, String marca, String categoria, String logo, ArrayList<String> fotos) {
        this.id = id;
        this.titulo = titulo;
        this.descripcion = descripcion;
        this.precio = precio;
        this.descuento = descuento;
        this.rating = rating;
        this.stock = stock;
        this.marca = marca;
        this.categoria = categoria;
        this.logo = logo;
        this.fotos = fotos;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public long getPrecio() {
        return precio;
    }

    public void setPrecio(long precio) {
        this.precio = precio;
    }

    public double getDescuento() {
        return descuento;
    }

    public void setDescuento(double descuento) {
        this.descuento = descuento;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public long getStock() {
        return stock;
    }

    public void setStock(long stock) {
        this.stock = stock;
    }

    public String getMarca() {
        return marca;
    }

    public void setMarca(String marca) {
        this.marca = marca;
    }

    public String getCategoria() {
        return categoria;
    }

    public void setCategoria(String categoria) {
        this.categoria = categoria;
    }

    public String getLogo() {
        return logo;
    }

    public void setLogo(String logo) {
        this.logo = logo;
    }

    public ArrayList<String> getFotos() {
        return fotos;
    }

    public void setFotos(ArrayList<String> fotos) {
        this.fotos = fotos;
    }
}
