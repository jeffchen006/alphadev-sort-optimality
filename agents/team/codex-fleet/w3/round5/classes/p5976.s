# n=5 model=out iset=I1 prefix14_class=5976
cmp P0, P2
cmovg S1, P2
mov S0, P1
cmovle S1, P0
cmovg P2, P0
mov S2, S1
cmp P1, P3
cmovg S0, P3
cmovge P3, P1
cmp P2, P3
cmovl P1, P3
cmovle P3, P2
cmovl P2, P1
mov P0, P3
