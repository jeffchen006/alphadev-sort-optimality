# n=5 model=out iset=I1 prefix14_class=10346
mov S0, P0
cmp P3, S0
cmovle P0, P3
cmovg S0, P3
mov S2, P2
cmp P1, S2
cmovge P2, P1
cmovl S2, P1
mov S1, P2
cmp P2, S0
cmovg P2, S0
cmovge S0, S1
cmp P0, S2
cmovle S0, S2
