package com.example.tarea3viewmodelrom.data;

import android.app.Application;
import android.widget.Toast;

import androidx.lifecycle.LiveData;

import com.example.tarea3viewmodelrom.encapsulaciones.Tarea;

import java.util.List;

public class TareaRepository {
    private TareaDao tDao;

    private LiveData<List<Tarea>> tall;

    TareaRepository(Application application){
        TareaDatabase db = TareaDatabase.getDatabase(application);
        tDao = db.tareaDao();
        tall = tDao.getAll();
    }

    public LiveData<List<Tarea>> getAllTareas() {
        return tall;
    }

    public void insert(Tarea tarea){
        TareaDatabase.databaseWriteExecutor.execute(() -> {
            tDao.insert(tarea);
        });
    }

    public void delete(Tarea tarea){
        TareaDatabase.databaseWriteExecutor.execute(() -> {
            tDao.delete(tarea);
        });
    }
    public void update(Tarea tarea){
        TareaDatabase.databaseWriteExecutor.execute(() -> {
            tDao.update(tarea);
        });
    }

}
