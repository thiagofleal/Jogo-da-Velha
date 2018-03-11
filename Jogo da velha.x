Incluir: @"Menu.cx";
Incluir: "Tabuleiro.cx";
Incluir: "Controle.cx";
Incluir: "Jogo.cx";

limpar_tela()
{
	Tela.descarregar();
	Comando("cls");
}

Principal()
{
	Inteiro: op, jogador = 1;
	
	Objeto: tabuleiro = novo Tabuleiro(10, 5);
	Objeto: controle = novo Controle(tabuleiro);
	Objeto: jogo = novo Jogo(tabuleiro, controle, controle);
	Objeto: menu = novo Menu(10, 5, 0);
	
	menu.alterarAlternativas(Vetor.texto("Novo Jogo", "Configurar", "Sair"));
	menu.alterarCores(15, 0, 8, 0);
	menu.prefixo("\26", " ");
	
	fazer
	{
		limpar_tela();
		op = menu.exibir();
		
		se(op == 0)
		{
			tabuleiro.reiniciar();
			Inteiro: vencedor = jogo.iniciar(jogador);
			Tecla.ler();
			
			se(vencedor == 0)
			{
				se(jogador == 1)
					jogador = 2;
				senao
					jogador = 1;
			}
			senao
			{
				jogador = vencedor;
			}
		}
		se(op == 1)
		{
			Objeto: menuConfig = novo Menu(10, 5, 0);
			Texto[]: alternativas = Vetor.texto("Alterar cores", "Alterar caracteres", "Modo de jogo", "Voltar");
			Inteiro: opConfig;
			
			menuConfig.alterarAlternativas(alternativas);
			menuConfig.alterarCores(15, 0, 8, 0);
			menuConfig.prefixo("\26", " ");
			
			fazer
			{
				limpar_tela();
				opConfig = menuConfig.exibir();
				limpar_tela();
				
				se(opConfig == 0)
				{
					Objeto: menuCores = novo Menu(10, 5, 0);
					Texto[]: txtCores = Vetor.texto(
						"", "", "", "", "", "", "", "", "", "", "", "", "", "", ""
					);
					Inteiro: []cor = Vetor.inteiro(tabuleiro.cor(1), tabuleiro.cor(2));
					
					menuCores.alterarCores(15, 0, 0, 0);
					menuCores.alterarAlternativas(txtCores);
					menuCores.prefixo("\26", " ");
					
					para(Inteiro: i; i < cor.tamanho; i++)
					{
						para(Inteiro: j; j < txtCores.tamanho; j++)
						{
							Posicionar(menuCores.x() + 1, menuCores.y() + j);
							Cores(j, 0);
							Tela.escrever(tabuleiro.jogador(i + 1));
						}
						
						Posicionar(menuCores.x() + 10, menuCores.y() + txtCores.tamanho / 2 + i);
						Cores(8, 0);
						Texto: txt = "Jogador " << i + 1 << ": |";
						Tela.escrever(txt << " |");
						cor[i] = menuCores.exibir();
						Posicionar(menuCores.x() + 10 + txt.tamanho, menuCores.y() + txtCores.tamanho / 2 + i);
						Cores(cor[i], 0);
						Tela.escrever(tabuleiro.jogador(i + 1));
						Tecla.ler();
					}
					
					tabuleiro.alterarCores(0, cor[0], cor[1], 0, 7);
					cor.liberar();
					menuCores.destruir();
				}
				
				se(opConfig == 1)
				{
					Objeto: menuCaracteres = novo Menu(10, 5, 0);
					Texto[]: txtCaracteres = Vetor.texto(
						"X", "O", "@", "*", "+", "?", "!"
					);
					Caractere: []img = Vetor.caractere(tabuleiro.jogador(1), tabuleiro.jogador(2));
					
					menuCaracteres.alterarAlternativas(txtCaracteres);
					menuCaracteres.prefixo("\26", " ");
					
					para(Inteiro: i; i < img.tamanho; i++)
					{
						menuCaracteres.alterarCores(tabuleiro.cor(i + 1), 0, 8, 0);
						para(Inteiro: j; j < txtCaracteres.tamanho; j++)
						{
							Posicionar(menuCaracteres.x() + 1, menuCaracteres.y() + j);
							Cores(j, 0);
							Tela.escrever(tabuleiro.jogador(i + 1));
						}
						
						Posicionar(menuCaracteres.x() + 10, menuCaracteres.y() + txtCaracteres.tamanho / 2 + i);
						Cores(8, 0);
						Texto: txt = "Jogador " << i + 1 << ": |";
						Tela.escrever(txt << " |");
						img[i] = txtCaracteres[menuCaracteres.exibir()].caractere(0);
						Posicionar(menuCaracteres.x() + 10 + txt.tamanho, menuCaracteres.y() + txtCaracteres.tamanho / 2 + i);
						Cores(tabuleiro.cor(i + 1), 0);
						Tela.escrever(img[i]);
						Tecla.ler();
					}
					
					tabuleiro.alterarJogadores(img[0], img[1]);
					img.liberar();
					menuCaracteres.destruir();
				}
				
				se(opConfig == 2)
				{
					Objeto: menuModo = novo Menu(10, 5, 0);
					Texto[]: txtModo = Vetor.texto("2 jogadores");
					
					menuModo.alterarAlternativas(txtModo);
					menuModo.alterarCores(15, 0, 8, 0);
					menuModo.prefixo("\26", " ");
					
					Inteiro: opModo = menuModo.exibir();
					
					se(opModo == 0)
						jogo.alterarControladores(controle, controle);
					
					menuModo.destruir();
					txtModo.liberar();
				}
			}
			enquanto(opConfig != 3);
			
			menuConfig.destruir();
			alternativas.liberar();
		}
	}
	enquanto(op != 2);
}