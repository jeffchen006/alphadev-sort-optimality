# n=5 model=out iset=I1 prefix14_class=13218
mov S2, P1
cmp P0, P3
cmovg S0, P3
cmovg P3, P0
cmovg P0, S0
cmp P1, P2
cmovg S2, P2
cmovle P1, P2
mov P2, P0
cmp S2, P2
cmovg P0, S2
cmovl P2, S2
cmp P1, P3
cmovle S2, P1
