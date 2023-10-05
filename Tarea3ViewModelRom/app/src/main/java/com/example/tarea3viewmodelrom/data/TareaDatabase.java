package com.example.tarea3viewmodelrom.data;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;
import androidx.sqlite.db.SupportSQLiteDatabase;

import com.example.tarea3viewmodelrom.encapsulaciones.Tarea;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Database(entities = {Tarea.class}, version = 1, exportSchema = false)
public abstract class TareaDatabase extends RoomDatabase {
    public abstract TareaDao tareaDao();

    private static volatile TareaDatabase INSTANCE;

    private static final int NUMBER_OF_THREADS = 4;
    static final ExecutorService databaseWriteExecutor =
            Executors.newFixedThreadPool(NUMBER_OF_THREADS);


    static TareaDatabase getDatabase(final Context context) {
        if (INSTANCE == null) {
            synchronized (TareaDatabase.class) {
                if (INSTANCE == null) {
                    INSTANCE = Room.databaseBuilder(context.getApplicationContext(),
                                    TareaDatabase.class, "tarea_database11")
                            .addCallback(sRoomDatabaseCallback)
                            .build();
                }
            }
        }
        return INSTANCE;
    }

    private static RoomDatabase.Callback sRoomDatabaseCallback = new RoomDatabase.Callback() {
        @Override
        public void onCreate(@NonNull SupportSQLiteDatabase db) {
            super.onCreate(db);

            databaseWriteExecutor.execute(() -> {

                TareaDao dao =  INSTANCE.tareaDao();
                Tarea t = new Tarea("1","1",false);
                dao.insert(t);

            });
        }
    };

}
