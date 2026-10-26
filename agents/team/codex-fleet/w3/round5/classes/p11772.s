# n=5 model=out iset=I1 prefix14_class=11772
cmp P3, P0
mov S0, P0
cmovge P0, P3
cmovg P3, S0
mov S1, P1
cmp P2, S1
cmovl P1, P2
cmovg S1, P2
cmp P0, S1
cmovge S0, S1
cmovge S1, P0
cmovge P0, S0
cmp P1, P3
mov S1, P3
