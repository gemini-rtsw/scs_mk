#include <stdio.h>
#include <stddef.h>

/*--- Your struct definitions ---*/
typedef struct
{
    float           notUsed;
    float           follow1;
    float           follow2;
    float           follow3;
    float           current1;
    float           current2;
    float           current3;
    float           kaman1;
    float           kaman2;
    float           kaman3;
    float           integ1;
    float           integ2;
    float           integ3;
    long            rawXTilt;
    long            rawYTilt;
    long            rawZFocus;
    float           TMS2realXTilt;
    float           TMS2realYTilt;
    float           TMS2realZFocus;
    float           rad2arcsec;
    float           mm2um;
    float           xTilt; 
    float           yTilt;
    float           zFocus; 
    long            NR;
    long            initState;
    long            errorSystem;
    long            errorCode;
    float           azguide;
    float           elguide;
    float           zcmd;
    float           azcmd;
    float           elcmd;
    float           zunused;
    float           aztotcmd;
    float           eltotcmd;
    float           ztotcmd;
    float           azrate;
    float           elrate;
    float           zrate;
    float           azerr;
    float           elerr;
    float           zerr;
    float           azrf;
    float           elrf;
    float           zrf;
    float           azcor;
    float           elcor;
    float           zcor;
    float           azf;
    float           elf;
    float           zf;
    float           azp;
    float           elp;
    float           zp;
    float           azi;
    float           eli;
    float           zi;
    float           azd;
    float           eld;
    float           zd;
    float           g;      /* Not yet available. Here to end of page */
    float           azcg;
    float           elcg;
    float           zcg;
    float           azsmg0;
    float           elsmg0;
    float           zsmg0;
    float           azsmg1;
    float           elsmg1;
    float           zsmg1;
    float           azsmg2;
    float           elsmg2;
    float           zsmg2;
    float           pad[182]; 
} m2EngData;

typedef struct
{
    /* Status Block 2 Section Added in 2001 to increase diagnostics */
    /* This matches m2EngData in the SCS Page 13a                   */
    float notUsed;                          
    float followerError0;                   
    float followerError1;                   
    float followerError2;                   
    float kam0;                             
    float kam1;                             
    float kam2;                             
    float mirrorActuatorCurrent0;           
    float mirrorActuatorCurrent1;           
    float mirrorActuatorCurrent2;           
    float integratorX;                      
    float integratorY;                      
    float integratorZ;                      
    long  initialize_state;              
    long  error_system_id;               
    long  error_code;                    
    float mirrorRawOffloaderError0;         
    float mirrorRawOffloaderError1;         
    float mirrorRawOffloaderError2;         
    float mirrorFiltOffloaderError0;        
    float mirrorFiltOffloaderError1;        
    float mirrorFiltOffloaderError2;        
    float steerX;                           
    float steerY;                           
    float steerZ;                           
    float refX;                             
    float refY;                             
    float refZ;                             
    float cmdX;                             
    float cmdY;                             
    float cmdZ;                             
    float posErrorDerivativeX;              
    float posErrorDerivativeY;              
    float posErrorDerivativeZ;              
    float posErrorProportionalX;            
    float posErrorProportionalY;            
    float posErrorProportionalZ;            
    float mirrorRawforceX;                  
    float mirrorRawforceY;                  
    float mirrorRawforceZ;                  
    float mirrorForceX;                     
    float mirrorForceY;                     
    float mirrorForceZ;                     
    float mNotch1XZeta;                     
    float mNotch1XFreq;                     
    float mNotch1XLevel;                    
    float mNotch1YZeta;                     
    float mNotch1YFreq;                     
    float mNotch1YLevel;                    
    float mNotch1ZZeta;                     
    float mNotch1ZFreq;                     
    float mNotch1ZLevel;                    
    float mNotch2XZeta;                     
    float mNotch2XFreq;                     
    float mNotch2XLevel;                    
    float mNotch2YZeta;                     
    float mNotch2YFreq;                     
    float mNotch2YLevel;                    
    float mNotch2ZZeta;                     
    float mNotch2ZFreq;                     
    float mNotch2ZLevel;                    
    float mKamLinCoeffSlope0;               
    float mKamLinCoeffOffset0;              
    float mKamLinCoeffSlope1;               
    float mKamLinCoeffOffset1;              
    float mKamLinCoeffSlope2;               
    float mKamLinCoeffOffset2;              
    float mirrorProportionalGainX;          
    float mirrorProportionalGainY;          
    float mirrorProportionalGainZ;          
    float mirrorIntegratorGainX;            
    float mirrorIntegratorGainY;            
    float mirrorIntegratorGainZ;            
    float mirrorDerivativeGainX;            
    float mirrorDerivativeGainY;            
    float mirrorDerivativeGainZ;            
    float mirrorSystemGain;                 
    float positionErrorX;                   
    float positionErrorY;                   
    float positionErrorZ;                   
    float mE_0;                             
    float mE_1;                             
    float mE_2;                             
    float mEcosRaw_0;                       
    float mEcosRaw_1;                       
    float mEcosRaw_2;                       
    float mEsinRaw_0;                       
    float mEsinRaw_1;                       
    float mEsinRaw_2;                       
} newEngData;

/*--- A simple macro to print the offset of a member ---*/
#define PRINT_OFFSET(struct_type, member) \
    printf("  %-35s : %zu\n", #member, offsetof(struct_type, member));

int main(void)
{
    /* Print overall size and alignment information */
    printf("=== m2EngData ===\n");
    printf("sizeof(m2EngData) = %zu bytes\n", sizeof(m2EngData));
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
    printf("_Alignof(m2EngData) = %zu bytes\n", _Alignof(m2EngData));
#else
    printf("Alignment info not available (pre-C11)\n");
#endif

    printf("\nKey member offsets in m2EngData:\n");
    PRINT_OFFSET(m2EngData, notUsed);
    PRINT_OFFSET(m2EngData, follow1);
    PRINT_OFFSET(m2EngData, current1);
    PRINT_OFFSET(m2EngData, kaman1);
    PRINT_OFFSET(m2EngData, integ1);
    PRINT_OFFSET(m2EngData, rawXTilt);
    PRINT_OFFSET(m2EngData, xTilt);
    PRINT_OFFSET(m2EngData, NR);
    PRINT_OFFSET(m2EngData, azguide);
    PRINT_OFFSET(m2EngData, azrate);
    PRINT_OFFSET(m2EngData, azrf);
    PRINT_OFFSET(m2EngData, pad);

    printf("\n=== newEngData ===\n");
    printf("sizeof(newEngData) = %zu bytes\n", sizeof(newEngData));
#if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 201112L
    printf("_Alignof(newEngData) = %zu bytes\n", _Alignof(newEngData));
#else
    printf("Alignment info not available (pre-C11)\n");
#endif

    printf("\nKey member offsets in newEngData:\n");
    PRINT_OFFSET(newEngData, notUsed);
    PRINT_OFFSET(newEngData, followerError0);
    PRINT_OFFSET(newEngData, kam0);
    PRINT_OFFSET(newEngData, integratorX);
    PRINT_OFFSET(newEngData, initialize_state);
    PRINT_OFFSET(newEngData, steerX);
    PRINT_OFFSET(newEngData, cmdX);
    PRINT_OFFSET(newEngData, posErrorDerivativeX);
    PRINT_OFFSET(newEngData, mirrorRawforceX);
    PRINT_OFFSET(newEngData, mirrorForceX);

    return 0;
}
