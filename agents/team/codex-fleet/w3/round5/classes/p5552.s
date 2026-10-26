# n=5 model=out iset=I1 prefix14_class=5552
mov S2, P1
cmp P1, P3
cmovl S2, P3
cmovge P1, P3
mov S0, P2
cmp P2, P0
cmovl P2, P0
cmovl P0, S0
cmp P1, P0
cmovle S1, P0
cmovg S1, P1
cmovl P0, P1
cmp S2, P2
cmovg P0, P2
