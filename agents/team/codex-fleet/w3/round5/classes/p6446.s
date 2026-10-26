# n=5 model=out iset=I1 prefix14_class=6446
cmp P1, P2
cmovle S0, P1
cmovle P1, P2
cmovle P2, S0
mov S2, P0
cmp P0, P3
cmovle P0, P3
cmovg S2, P3
mov P3, P1
cmp P3, P0
cmovge P1, P0
cmovg P0, P3
mov P0, P2
cmp P2, S2
