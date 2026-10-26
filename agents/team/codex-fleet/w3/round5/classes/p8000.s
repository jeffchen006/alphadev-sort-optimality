# n=5 model=out iset=I1 prefix14_class=8000
cmp P2, P0
cmovg S1, P2
cmovge P2, P0
cmovg P0, S1
cmp P3, P1
cmovle S0, P3
cmovg S0, P1
mov S2, S0
cmovle P3, P1
cmovg P1, P3
cmp P2, S2
cmovle S0, P2
cmovg S2, P2
cmovl P2, S2
