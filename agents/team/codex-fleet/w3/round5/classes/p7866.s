# n=5 model=out iset=I1 prefix14_class=7866
cmp P0, P1
mov S2, P1
cmovl S2, P0
cmovge P1, P0
cmp P3, P2
mov S1, P2
cmovl S1, P3
cmovg P2, P3
mov S0, S1
cmp S2, S1
cmovle S1, S2
cmovg S0, S2
cmp P2, P1
cmovge P3, P2
