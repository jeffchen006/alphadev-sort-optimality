# n=5 model=out iset=I1 prefix14_class=4265
mov S1, P3
cmp S1, P1
cmovg S1, P1
cmovle P3, P1
cmp P2, P0
cmovg S2, P0
cmovge P0, P2
cmovg P2, S2
mov S0, P2
cmp S1, S0
cmovle S0, S1
cmovl S1, P2
cmp P3, P0
cmovle P1, P0
