# n=5 model=out iset=I1 prefix14_class=13698
mov S2, P0
cmp P0, P1
cmovg S2, P1
cmovle P0, P1
cmp P3, P2
cmovge P1, P2
cmovg P2, P3
cmovge P3, P1
cmp P3, S2
cmovl S1, P3
cmovge S1, S2
cmovg S2, P3
mov S0, P0
cmp P2, P0
