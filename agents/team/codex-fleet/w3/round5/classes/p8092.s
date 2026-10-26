# n=5 model=out iset=I1 prefix14_class=8092
cmp P2, P3
cmovle S0, P2
cmovge S0, P3
cmovle P2, P3
cmp P0, P1
cmovge P3, P1
mov S2, S0
mov S1, P2
cmovge P1, P0
cmovg P0, P3
cmp P0, S2
cmovl S2, P0
cmovg S0, P0
cmovle P0, S0
