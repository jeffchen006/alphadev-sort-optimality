# n=5 model=out iset=I1 prefix14_class=734
mov S2, P1
cmp P0, P2
cmovle S0, P0
cmovg S0, P2
cmovl P0, P2
cmp P1, P3
cmovl S2, P3
cmovge P1, P3
cmp S2, P0
cmovle P2, S2
cmovl S2, P0
cmovle P0, P2
cmp P1, S0
cmovg P2, P1
