# n=5 model=out iset=I1 prefix14_class=8744
cmp P1, P3
cmovle S2, P3
cmovg S2, P1
mov S0, S2
mov S1, P2
cmovge P1, P3
cmp P2, P0
cmovl S1, P0
cmovl P0, P2
cmp S2, S1
cmovg S0, S1
cmovl S2, S1
cmp P1, P0
cmovge P2, P0
