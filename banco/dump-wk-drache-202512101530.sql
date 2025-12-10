-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: mysql.drache.net.br    Database: drache
-- ------------------------------------------------------
-- Server version	5.5.5-10.2.36-MariaDB-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `clientes`
--

DROP TABLE IF EXISTS `clientes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clientes` (
  `codigo` int(11) NOT NULL,
  `nome` varchar(100) NOT NULL,
  `cidade` varchar(100) DEFAULT NULL,
  `uf` char(2) DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clientes`
--

LOCK TABLES `clientes` WRITE;
/*!40000 ALTER TABLE `clientes` DISABLE KEYS */;
INSERT INTO `clientes` VALUES (1,'Comercial São João','São Paulo','SP'),(2,'Supermercado Bom Preço','Rio de Janeiro','RJ'),(3,'Loja Central','Belo Horizonte','MG'),(4,'Mercado União','Curitiba','PR'),(5,'Atacado Paulista','Campinas','SP'),(6,'Distribuidora Alpha','Santos','SP'),(7,'Comercial Beta','Sorocaba','SP'),(8,'Loja do Povo','Porto Alegre','RS'),(9,'Superlar','Florianópolis','SC'),(10,'Mercado Econômico','Joinville','SC'),(11,'Rede Vitória','Vitória','ES'),(12,'Comercial Minas','Contagem','MG'),(13,'Super Rio','Niterói','RJ'),(14,'Comercial Sul','Caxias do Sul','RS'),(15,'Atacado Brasil','Brasília','DF'),(16,'Loja Popular','Goiânia','GO'),(17,'Centro Comercial','Manaus','AM'),(18,'Mercado Tropical','Belém','PA'),(19,'Rede Nordeste','Recife','PE'),(20,'Super Bahia','Salvador','BA');
/*!40000 ALTER TABLE `clientes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos`
--

DROP TABLE IF EXISTS `pedidos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos` (
  `numero_pedido` int(11) NOT NULL,
  `data_emissao` date NOT NULL,
  `codigo_cliente` int(11) NOT NULL,
  `valor_total` decimal(15,2) NOT NULL,
  PRIMARY KEY (`numero_pedido`),
  KEY `idx_pedidos_codigo_cliente` (`codigo_cliente`),
  CONSTRAINT `fk_pedidos_clientes` FOREIGN KEY (`codigo_cliente`) REFERENCES `clientes` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos`
--

LOCK TABLES `pedidos` WRITE;
/*!40000 ALTER TABLE `pedidos` DISABLE KEYS */;
INSERT INTO `pedidos` VALUES (1,'2025-12-10',1,25.90),(2,'2025-12-10',1,396.00);
/*!40000 ALTER TABLE `pedidos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pedidos_produtos`
--

DROP TABLE IF EXISTS `pedidos_produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pedidos_produtos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `numero_pedido` int(11) NOT NULL,
  `codigo_produto` int(11) NOT NULL,
  `quantidade` decimal(15,3) NOT NULL,
  `valor_unitario` decimal(15,2) NOT NULL,
  `valor_total` decimal(15,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_pedprod_numero_pedido` (`numero_pedido`),
  KEY `idx_pedprod_codigo_produto` (`codigo_produto`),
  CONSTRAINT `fk_pedprod_pedidos` FOREIGN KEY (`numero_pedido`) REFERENCES `pedidos` (`numero_pedido`),
  CONSTRAINT `fk_pedprod_produtos` FOREIGN KEY (`codigo_produto`) REFERENCES `produtos` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pedidos_produtos`
--

LOCK TABLES `pedidos_produtos` WRITE;
/*!40000 ALTER TABLE `pedidos_produtos` DISABLE KEYS */;
INSERT INTO `pedidos_produtos` VALUES (1,1,1,1.000,25.90,25.90),(2,2,2,22.000,8.50,187.00),(3,2,5,55.000,3.80,209.00);
/*!40000 ALTER TABLE `pedidos_produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `produtos`
--

DROP TABLE IF EXISTS `produtos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `produtos` (
  `codigo` int(11) NOT NULL,
  `descricao` varchar(150) NOT NULL,
  `preco_venda` decimal(15,2) NOT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `produtos`
--

LOCK TABLES `produtos` WRITE;
/*!40000 ALTER TABLE `produtos` DISABLE KEYS */;
INSERT INTO `produtos` VALUES (1,'Arroz Tipo 1 5kg',25.90),(2,'Feijão Carioca 1kg',8.50),(3,'Açúcar Refinado 1kg',4.20),(4,'Café Torrado e Moído 500g',12.90),(5,'Macarrão Espaguete 500g',3.80),(6,'Óleo de Soja 900ml',7.10),(7,'Leite Integral 1L',5.30),(8,'Manteiga 200g',9.90),(9,'Biscoito Cream Cracker 400g',6.40),(10,'Detergente Líquido 500ml',2.50),(11,'Sabão em Pó 1kg',11.90),(12,'Amaciante de Roupas 2L',14.50),(13,'Sabonete 90g',2.10),(14,'Shampoo 350ml',15.90),(15,'Condicionador 350ml',16.90),(16,'Papel Higiênico 12 rolos',18.50),(17,'Água Mineral 1,5L',3.20),(18,'Refrigerante Cola 2L',8.90),(19,'Suco de Laranja 1L',6.80),(20,'Chocolate Barra 100g',5.70);
/*!40000 ALTER TABLE `produtos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'drache'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-10 15:30:58
