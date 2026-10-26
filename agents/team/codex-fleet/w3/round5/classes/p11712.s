# n=5 model=out iset=I1 prefix14_class=11712
mov S0, P0
cmp P1, P0
cmovge P0, P1
cmovl S0, P1
cmp P2, P3
cmovge P1, P3
cmovg P3, P2
cmovg P2, P1
mov S2, S0
cmp P0, P3
mov S1, P3
cmovle S1, P0
cmovge P3, P0
cmp P2, S0
