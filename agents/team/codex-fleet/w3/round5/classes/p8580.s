# n=5 model=out iset=I1 prefix14_class=8580
cmp P3, P0
cmovle S2, P3
mov S0, P1
cmovle P3, P0
cmovle P0, S2
cmp P1, P2
cmovle P1, P2
cmovg S0, P2
cmp P3, P1
mov P2, P3
cmovl P3, P1
mov P3, S0
cmovge P2, P1
cmp P0, S0
