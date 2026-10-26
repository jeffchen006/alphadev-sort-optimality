# n=5 model=out iset=I1 prefix14_class=9295
cmp P0, P3
cmovg S0, P3
cmovle S0, P0
cmovge P3, P0
cmp P1, P2
cmovle P0, P2
cmovl P2, P1
cmovle P1, P0
mov S2, P2
cmp S0, P2
cmovg P2, S0
cmovl S2, S0
cmp P3, P1
cmovle S0, P3
