# n=5 model=out iset=I1 prefix14_class=4279
cmp P3, P1
mov S0, P3
cmovg P3, P1
cmovl S0, P1
cmp P0, P2
cmovge P1, P2
cmovle P1, P0
cmovl P0, P2
cmp P1, P3
cmovle S2, P3
cmovle P3, P1
cmovg S2, P1
cmp S0, P0
cmovg P1, P0
