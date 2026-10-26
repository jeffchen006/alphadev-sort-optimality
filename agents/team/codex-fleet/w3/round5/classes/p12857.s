# n=5 model=out iset=I1 prefix14_class=12857
cmp P1, P0
cmovg S1, P1
cmovg P1, P0
mov S0, P3
cmovg P0, S1
mov S2, P1
cmp P3, P2
cmovge P3, P2
cmovl S0, P2
cmp S2, P3
cmovle S2, P3
cmovle P3, P1
cmovle P1, S2
mov P3, S0
