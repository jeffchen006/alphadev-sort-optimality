# n=5 model=out iset=I1 prefix14_class=9683
mov S2, P0
cmp P0, P3
cmovle S2, P3
mov S1, S2
cmovl P3, P0
cmp P2, P1
cmovle P0, P1
cmovle P1, P2
cmovl P2, P0
cmp S2, P2
mov S0, P3
cmovg S1, P2
cmovg P2, S2
mov S2, S1
