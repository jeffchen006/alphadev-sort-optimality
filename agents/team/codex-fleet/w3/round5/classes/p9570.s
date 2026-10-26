# n=5 model=out iset=I1 prefix14_class=9570
cmp P1, P3
cmovle S1, P1
mov S0, P2
cmovle P1, P3
cmovle P3, S1
cmp S0, P0
cmovg P2, P0
cmovge P0, S0
cmovl S0, P0
cmp P1, P0
cmovle P0, P1
cmovle P1, S0
mov S0, P0
mov S2, P3
