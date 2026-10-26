# n=5 model=out iset=I1 prefix14_class=6246
mov S1, P2
cmp P3, P1
cmovg S0, P1
cmovge P1, P3
cmovg P3, S0
cmp P0, S1
cmovge P2, P0
cmovl S1, P0
mov P0, S1
mov S2, P1
cmp P2, P1
cmovge S2, P2
cmovge P2, P1
cmovle P1, P2
