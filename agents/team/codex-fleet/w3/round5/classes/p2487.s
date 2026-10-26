# n=5 model=out iset=I1 prefix14_class=2487
cmp P1, P3
cmovle S2, P1
cmovle P1, P3
cmovge S2, P3
mov P3, S2
cmp P0, P2
cmovg S0, P2
cmovg P2, P0
cmovg P0, S0
mov S1, P1
cmp P1, P2
cmovl P1, P2
cmovle P2, S1
mov S1, P2
