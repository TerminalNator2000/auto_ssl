@TerminalNator2000

### **How to Use the Script**  
1. **Save the Script:**  
   Save the script to a file, e.g., `generate_ssl.sh`.

2. **Make It Executable:**  
   Run the following command:  
   ```bash
   chmod +x generate_ssl.sh
   ```

3. **Run the Script:**  
   Execute the script with:  
   ```bash
   ./generate_ssl.sh
   ```

4. **Generated Files:**  
   - `rootCA.key`: Root CA private key.  
   - `rootCA.pem`: Root CA certificate.  
   - `server.key`: Server private key.  
   - `server.crt`: Server SSL certificate.

5. **Install the Root CA in Your System/Browser:**  
   Use the instructions in **Step 6** from the previous section to trust the `rootCA.pem` file.

---

### **Enhancements and Customization**
- Modify the `$DOMAIN` and `$ALT_NAMES` variables for your domain and Subject Alternative Names (SANs).
- To integrate with Docker, mount the generated certificates into your container and configure your app/server.

