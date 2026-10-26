# n=5 model=out iset=I1 prefix14_class=11169
cmp P3, P1
cmovg S0, P3
cmovg P3, P1
cmovg P1, S0
mov S2, P0
cmp P2, P0
cmovg P0, P2
cmovle S2, P2
mov S1, P1
cmp P0, S1
cmovl P1, P0
cmovle P0, S1
cmp S2, P3
mov S1, P1
