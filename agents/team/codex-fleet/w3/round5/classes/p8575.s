# n=5 model=out iset=I1 prefix14_class=8575
cmp P3, P2
cmovle S2, P3
mov S0, P0
cmovle P3, P2
cmovle P2, S2
cmp S0, P1
cmovge P0, P1
cmovl S0, P1
mov P1, S0
cmp P1, P3
cmovle S0, P3
mov S1, P0
cmovg P1, P3
cmovle P3, P1
