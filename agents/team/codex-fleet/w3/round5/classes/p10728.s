# n=5 model=out iset=I1 prefix14_class=10728
mov S2, P0
cmp P1, S2
cmovle S2, P1
cmovle P1, P0
cmp P2, P3
cmovle S1, P2
cmovle P2, P3
cmovle P3, S1
mov S0, P1
cmp P1, P2
cmovg S0, P2
cmovg P2, P1
mov P1, S2
mov P2, S0
