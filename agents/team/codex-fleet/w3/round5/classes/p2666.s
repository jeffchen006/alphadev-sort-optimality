# n=5 model=out iset=I1 prefix14_class=2666
cmp P0, P3
cmovle S0, P3
cmovl P3, P0
mov S1, P1
cmovg S0, P0
mov P0, P3
cmp S1, P2
cmovge P1, P2
cmovg P2, S1
cmp S0, P2
cmovle S2, P2
cmovle P2, S0
cmovle S0, S2
cmp P1, P3
