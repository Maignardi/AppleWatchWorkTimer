import SwiftUI

struct ContentView: View {
    @State private var horaChegada: String = UserDefaults.standard.string(forKey: "HoraChegada") ?? ""
    @State private var totalHoras: String = UserDefaults.standard.string(forKey: "TotalHoras") ?? ""
    @State private var horarioSaida: String = UserDefaults.standard.string(forKey: "HorarioSaida") ?? ""
    @State private var showingHoraChegadaPicker = false
    @State private var showingTotalHorasPicker = false
    @State private var horaSelecionada = 0
    @State private var minutosSelecionados = 0
    
    let numeros = Array(0...9).map { String($0) }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    Text("Chegada")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    Text(horaChegada)
                        .font(.title)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                
                Button(action: {
                    showingHoraChegadaPicker = true
                }) {
                    Text("Escolher Chegada")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showingHoraChegadaPicker, onDismiss: saveData) {
                    HoraPickerView(horaSelecionada: $horaSelecionada, minutosSelecionados: $minutosSelecionados, hora: $horaChegada, onDismiss: {
                        showingHoraChegadaPicker = false
                    })
                }
                
                VStack {
                    Text("Expediente")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    Text(totalHoras)
                        .font(.title)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                
                Button(action: {
                    showingTotalHorasPicker = true
                }) {
                    Text("Escolher Expediente")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .sheet(isPresented: $showingTotalHorasPicker, onDismiss: saveData) {
                    HoraPickerView(horaSelecionada: $horaSelecionada, minutosSelecionados: $minutosSelecionados, hora: $totalHoras, onDismiss: {
                        showingTotalHorasPicker = false
                    })
                }
                
                Button(action: calcularHorarioSaida) {
                    Text("Calcular")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                
                VStack {
                    Text("Horário de Saída")
                        .font(.headline)
                        .padding(.bottom, 10)
                    
                    Text(horarioSaida)
                        .font(.title)
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                
                Button(action: resetarHorario) {
                    Text("Resetar")
                        .font(.headline)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
        }
    }
    
    func calcularHorarioSaida() {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        guard !horaChegada.isEmpty, let horaChegadaDate = formatter.date(from: horaChegada) else {
            horarioSaida = ""
            return
        }
        
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = horaSelecionada
        components.minute = minutosSelecionados
        
        let horaSaidaDate = calendar.date(byAdding: components, to: horaChegadaDate)!
        
        let horaSaida = formatter.string(from: horaSaidaDate)
        horarioSaida = horaSaida
    }
    
    func resetarHorario() {
        horaChegada = ""
        totalHoras = ""
        horarioSaida = ""
    }
    
    private func saveData() {
        UserDefaults.standard.set(horaChegada, forKey: "HoraChegada")
        UserDefaults.standard.set(totalHoras, forKey: "TotalHoras")
        UserDefaults.standard.set(horarioSaida, forKey: "HorarioSaida")
    }
}

struct HoraPickerView: View {
    @Binding var horaSelecionada: Int
    @Binding var minutosSelecionados: Int
    @Binding var hora: String
    var onDismiss: () -> Void
    
    let horas = Array(0..<24)
    let minutos = Array(0..<60)
    
    var body: some View {
        VStack {
            Text("Escolha a Hora")
                .font(.headline)
                .padding(.bottom, 10)
            
            HStack {
                Picker("", selection: $horaSelecionada) {
                    ForEach(horas, id: \.self) { hora in
                        Text("\(hora)")
                            .tag(hora)
                    }
                }
                .frame(width: 80)
                .clipped()
                
                Text(":")
                
                Picker("", selection: $minutosSelecionados) {
                    ForEach(minutos, id: \.self) { minuto in
                        Text("\(minuto)")
                            .tag(minuto)
                    }
                }
                .frame(width: 80)
                .clipped()
            }
            .padding()
            
            Button(action: {
                horaSelecionada = horaSelecionada % 24
                minutosSelecionados = minutosSelecionados % 60
                
                let horaSelecionadaStr = String(format: "%02d:%02d", horaSelecionada, minutosSelecionados)
                hora = horaSelecionadaStr
                
                onDismiss()
            }) {
                Text("OK")
                    .font(.headline)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
