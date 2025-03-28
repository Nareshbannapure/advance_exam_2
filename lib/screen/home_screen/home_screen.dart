import 'package:advance_exam_2/controller/home_controller.dart';
import 'package:advance_exam_2/model/pro_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController updateNameController = TextEditingController();
  final TextEditingController updatePriceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: const Text("Shopping List"),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed('/cart'),
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder(
          stream: controller.getProducts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                  child: Text("No Products Found",
                      style: TextStyle(fontSize: 18, color: Colors.grey)));
            }

            var data = snapshot.data!.docs;

            return ListView.separated(
              itemCount: data.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                var productData = data[index].data();
                String productId = data[index].id;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      productData['name'],
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "\$${productData['price']}",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                    ),
                    trailing: Wrap(
                      spacing: 10,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart,
                              color: Colors.green),
                          onPressed: () {
                            controller.addToCart(ProductModel(
                              id: productId,
                              name: productData['name'],
                              price: productData['price'],
                            ));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            controller.deleteProduct(id: productId);
                          },
                        ),
                      ],
                    ),
                    onLongPress: () {
                      updateNameController.text = productData['name'];
                      updatePriceController.text = productData['price'];
                      _showUpdateProductSheet(productId, controller);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _showAddProductSheet(controller);
        },
        label: const Text("Add Product"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductSheet(HomeController controller) {
    // Clear controllers for new entry
    idController.clear();
    nameController.clear();
    priceController.clear();

    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Add New Product",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
              const SizedBox(height: 20),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: "Product Id",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Product Price",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                  onPressed: () async {
                    var id = idController.text.trim();
                    String name = nameController.text.trim();
                    String price = priceController.text.trim();

                    bool res = await controller.addProduct(
                        product: ProductModel(id: id, name: name, price: price));

                    if (res) {
                      Get.snackbar("Success", "Product Added",
                          backgroundColor: Colors.green,
                          colorText: Colors.white);
                      Get.back();
                    }
                  },
                  icon: const Icon(Icons.check),
                  label: const Text("Add Product"),
                ),
              )
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showUpdateProductSheet(
      String productId, HomeController controller) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Update Product",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
              const SizedBox(height: 20),
              TextField(
                controller: updateNameController,
                decoration: const InputDecoration(
                  labelText: "Product Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: updatePriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Product Price",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
                  onPressed: () async {
                    String name = updateNameController.text.trim();
                    String price = updatePriceController.text.trim();

                    bool updated = controller.updateProduct(
                      product: ProductModel(
                          id: productId, name: name, price: price),
                    );

                    if (updated) {
                      Get.snackbar("Success", "Product Updated",
                          backgroundColor: Colors.green,
                          colorText: Colors.white);
                      Get.back();
                    }
                  },
                  icon: const Icon(Icons.update),
                  label: const Text("Update"),
                ),
              )
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
