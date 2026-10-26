# n=5 model=out iset=I1 prefix14_class=57
mov S2, P2
mov S1, P0
cmp P1, S2
cmovle P2, P1
cmovl P1, S2
cmp P3, S1
cmovle S1, P3
cmovg P0, P3
mov P3, P2
mov S2, P0
cmp P3, S1
cmovl P2, S1
cmovg P3, S1
cmovg S1, P2
