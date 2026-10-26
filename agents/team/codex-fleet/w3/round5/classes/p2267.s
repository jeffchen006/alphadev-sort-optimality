# n=5 model=out iset=I1 prefix14_class=2267
mov S1, P3
cmp P0, P3
cmovge S1, P0
cmovge P0, P3
cmp P1, P2
cmovg S0, P1
cmovle S0, P2
mov P3, S0
cmovge P1, P2
cmp P3, S1
cmovl S0, S1
cmovl S1, P3
cmp P0, P1
cmovle P2, P1
