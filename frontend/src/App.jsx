import { useState, useEffect } from 'react';
import './App.css';

const API_URL = 'http://localhost:5000/api/vehicles';

function App() {
  const [vehicles, setVehicles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [form, setForm] = useState({ type: '', model: '' });

  // Charger les véhicules au démarrage de la page
  useEffect(() => {
    fetchVehicles();
  }, []);

  const fetchVehicles = async () => {
    try {
      setLoading(true);
      const res = await fetch(API_URL);
      if (!res.ok) throw new Error('Réponse serveur invalide');
      setVehicles(await res.json());
      setError(null);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.type || !form.model) return;
    try {
      const res = await fetch(API_URL, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ ...form, available: true }),
      });
      if (!res.ok) throw new Error('Création impossible');
      setForm({ type: '', model: '' });
      fetchVehicles(); // on recharge la liste après ajout
    } catch (err) {
      setError(err.message);
    }
  };

  return (
    <div className="container">
      <h1>🚗 Mobility</h1>

      <form onSubmit={handleSubmit} className="form">
        <input
          placeholder="Type (vélo, voiture...)"
          value={form.type}
          onChange={(e) => setForm({ ...form, type: e.target.value })}
        />
        <input
          placeholder="Modèle"
          value={form.model}
          onChange={(e) => setForm({ ...form, model: e.target.value })}
        />
        <button type="submit">Ajouter</button>
      </form>

      {loading && <p>Chargement...</p>}
      {error && <p className="error">Erreur : {error}</p>}

      <ul className="list">
        {vehicles.map((v) => (
          <li key={v._id} className="card">
            <strong>{v.model}</strong>
            <span className="type">{v.type}</span>
            <span className={v.available ? 'ok' : 'no'}>
              {v.available ? 'Disponible' : 'Indisponible'}
            </span>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;