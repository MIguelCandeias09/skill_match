# Importar dados para Firebase Firestore

## 1. Gerar chave privada do Firebase

1. Vai ao Firebase Console: https://console.firebase.google.com/
2. Clica na engrenagem ⚙️ → **Project settings**
3. Vai ao tab **Service accounts**
4. Clica **Generate new private key**
5. Clica **Generate key**
6. Um ficheiro JSON será descarregado
7. **Renomeia** para `serviceAccountKey.json`
8. **Move** para a pasta `firebase/`

⚠️ **IMPORTANTE:** Este ficheiro tem credenciais secretas! Nunca o partilhes ou commites no Git!

## 2. Instalar dependências

```bash
cd firebase
npm install
```

## 3. Executar importação

```bash
npm run import
```

## ✅ Pronto!

Os dados de `mongodb/users.json` e `mongodb/offers.json` serão importados para o Firestore.

Podes ver os dados no Firebase Console:
- Firestore Database → users (5 documentos)
- Firestore Database → offers (7 documentos)
