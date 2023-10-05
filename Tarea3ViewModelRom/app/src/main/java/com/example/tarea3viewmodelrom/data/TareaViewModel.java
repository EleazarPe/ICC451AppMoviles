package com.example.tarea3viewmodelrom.data;

import android.app.Application;
import android.widget.Toast;

import androidx.lifecycle.AndroidViewModel;
import androidx.lifecycle.LiveData;

import com.example.tarea3viewmodelrom.encapsulaciones.Tarea;

import java.util.List;

public class TareaViewModel extends AndroidViewModel {
    private TareaRepository tareaRepository;
    private final LiveData<List<Tarea>> tall;

    public TareaViewModel(Application application){
        super(application);
        tareaRepository = new TareaRepository(application);
        tall =tareaRepository.getAllTareas();
    }

    public LiveData<List<Tarea>> getAll(){
        return  tall;
    }
    public void insert(Tarea tarea){
        tareaRepository.insert(tarea);
    }
    public void update(Tarea tarea){

        tareaRepository.update(tarea);
    }
    public void delete(Tarea tarea){
        tareaRepository.delete(tarea);
    }

}
