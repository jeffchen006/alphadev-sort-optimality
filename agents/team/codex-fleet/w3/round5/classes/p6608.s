# n=5 model=out iset=I1 prefix14_class=6608
mov S1, P3
cmp P1, S1
cmovle P3, P1
cmovge S1, P1
mov S0, S1
cmovge P1, P3
cmp P2, P0
cmovl S2, P2
cmovl P2, P0
cmovl P0, S2
cmp S0, P2
cmovle S0, P2
cmovg S1, P2
cmp P0, P1
