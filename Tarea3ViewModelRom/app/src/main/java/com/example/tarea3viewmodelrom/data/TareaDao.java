package com.example.tarea3viewmodelrom.data;

import androidx.lifecycle.LiveData;
import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.OnConflictStrategy;
import androidx.room.Query;
import androidx.room.Update;

import com.example.tarea3viewmodelrom.encapsulaciones.Tarea;

import java.util.List;

@Dao
public interface TareaDao {
    @Insert(onConflict = OnConflictStrategy.IGNORE)
    void insert(Tarea tarea);

    @Delete
    void delete(Tarea tarea);

    @Update
    void update(Tarea tarea);

    @Query("SELECT * FROM tarea_table ORDER BY estado ASC,titulo ASC")
    LiveData<List<Tarea>> getAll();


}
