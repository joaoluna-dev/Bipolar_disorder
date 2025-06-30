# Define o nome do arquivo de entrada
arquivo_entrada <- "Resultado_meta_análise_p_0,05.csv"

# Verifica se o arquivo de entrada existe
if (!file.exists(arquivo_entrada)) {
  stop(paste("Erro: Arquivo de entrada não encontrado:", arquivo_entrada))
}

# Lê os dados do arquivo CSV
dados <- read.csv(arquivo_entrada, sep = "\t")

# Verifica se a coluna "zval" existe no dataframe
if (!"zval" %in% names(dados)) {
  stop("A coluna 'zval' não foi encontrada no arquivo. Verifique o nome da coluna.")
}

# Filtra os genes com zval positivo (up-regulated)
genes_up <- dados[dados$zval > 0, ]

# Filtra os genes com zval negativo (down-regulated)
genes_down <- dados[dados$zval < 0, ]

# Salva os resultados em novos arquivos CSV
write.csv(genes_up, "genes_up_regulated.csv", row.names = FALSE)
write.csv(genes_down, "genes_down_regulated.csv", row.names = FALSE)

# Imprime uma mensagem de confirmação
print("Análise concluída.")
print(paste("Genes up-regulated salvos em:", "genes_up_regulated.csv"))
print(paste("Genes down-regulated salvos em:", "genes_down_regulated.csv"))

