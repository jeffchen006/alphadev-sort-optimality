# n=5 model=out iset=I1 prefix14_class=9651
mov S1, P2
cmp P2, P1
cmovle P2, P1
cmovge S1, P1
mov S0, P3
cmp P3, P0
cmovge P3, P0
cmovle S0, P0
cmp S0, P2
mov S2, S0
cmovg S2, P2
cmovl S0, P2
cmp P3, S1
cmovge P2, P3
