# n=5 model=out iset=I1 prefix14_class=6857
mov S2, P3
cmp P0, P2
cmovl S0, P2
cmovl P2, P0
cmovl P0, S0
cmp S2, P1
cmovle S2, P1
cmovle P1, P3
mov S1, P0
cmp S2, S1
cmovg P0, S2
cmovle S1, S2
cmp P1, P2
cmovg S2, P2
