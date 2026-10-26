# n=5 model=out iset=I1 prefix14_class=775
cmp P2, P0
mov S1, P2
cmovg S1, P0
mov S2, P3
cmovl P2, P0
cmp P3, P1
cmovg P3, P1
cmovle S2, P1
mov P0, P3
cmp S2, P2
cmovg S0, S2
cmovle S0, P2
cmovle P2, S2
mov P1, P2
